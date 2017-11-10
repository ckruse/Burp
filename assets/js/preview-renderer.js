import CommonMark from "commonmark/lib";

export default class PreviewRenderer {
  constructor(container, subj, excerpt, content) {
    let tm = null;
    [subj, excerpt, content].forEach(el => {
      el.addEventListener("input", ev => {
        if (tm) {
          window.clearTimeout(tm);
        }

        tm = window.setTimeout(() => this.renderPreview(), 500);
      });
    });

    this.container = container;
    this.subj = subj;
    this.excerpt = excerpt;
    this.content = content;

    this.parser = new CommonMark.Parser();
    this.renderer = new CommonMark.HtmlRenderer();

    this.renderPreview();
  }

  renderPreview() {
    let subject = this.subj.value;

    let header = document.createElement("header");
    let h2 = document.createElement("h2");
    h2.appendChild(document.createTextNode(subject));

    header.appendChild(h2);

    let excerpt = document.createElement("div");
    excerpt.classList.add("excerpt");
    let excerptText = this.renderer.render(this.parser.parse(this.excerpt.value));
    excerpt.innerHTML = excerptText;

    let content = document.createElement("div");
    content.classList.add("content");
    let contentText = this.renderer.render(this.parser.parse(this.content.value));
    content.innerHTML = contentText;

    while (this.container.firstChild) {
      this.container.removeChild(this.container.firstChild);
    }

    this.container.appendChild(header);
    this.container.appendChild(excerpt);
    this.container.appendChild(content);
  }
}
