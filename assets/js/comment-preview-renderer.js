import MarkdownIt from "markdown-it";

export default class CommentPreviewRenderer {
  constructor(container, author, url, email, content) {
    let tm = null;
    [author, url, content, email].forEach((el) => {
      el.addEventListener("input", (ev) => {
        if (tm) {
          window.clearTimeout(tm);
        }

        tm = window.setTimeout(() => this.renderPreview(), 500);
      });
    });

    this.container = container;
    this.author = author;
    this.email = email;
    this.url = url;
    this.content = content;

    this.parser = MarkdownIt({ html: false });
    this.parser.disable("entity");
  }

  renderPreview() {
    document.getElementById("comment-preview-heading").classList.add("visible");
    document.getElementById("comment-preview").classList.add("visible");

    let author = this.author.value;
    // let url = this.url.value;
    let content = this.content.value;
    // let email = this.email.value;

    let header = document.createElement("header");

    // TODO we need MD5 in JS for this
    // if(email) {
    //   let img = document.createElement("img");
    //   img.setAttribute("src", "https://www.gravatar.com/avatar/")
    // }

    let h4 = document.createElement("h4");
    h4.appendChild(document.createTextNode(author));
    header.appendChild(h4);

    let contentHTML = this.parser.render(content);

    while (this.container.firstChild) {
      this.container.removeChild(this.container.firstChild);
    }

    this.container.appendChild(header);
    this.container.innerHTML += contentHTML;
  }
}
