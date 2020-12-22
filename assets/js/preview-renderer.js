import MarkdownIt from "markdown-it";

export default class PreviewRenderer {
  constructor(container, subj, excerpt, content) {
    let tm = null;
    [subj, excerpt, content].forEach((el) => {
      el.addEventListener("input", (ev) => {
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

    this.parser = MarkdownIt();

    this.renderPreview();
  }

  renderPreview() {
    const subject = this.subj.value;

    const header = document.createElement("header");
    const h2 = document.createElement("h2");
    h2.appendChild(document.createTextNode(subject));

    header.appendChild(h2);

    const excerpt = document.createElement("div");
    excerpt.classList.add("excerpt");
    excerpt.innerHTML = this.parser.render(this.excerpt.value);

    const content = document.createElement("div");
    content.classList.add("content");
    const contentText = this.parser.render(this.content.value);
    content.innerHTML = contentText;

    while (this.container.firstChild) {
      this.container.removeChild(this.container.firstChild);
    }

    this.container.appendChild(header);
    this.container.appendChild(excerpt);
    this.container.appendChild(content);
  }
}
