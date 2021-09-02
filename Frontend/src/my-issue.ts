import {LitElement, html, customElement, property, css} from 'lit-element'
import Issue from "./Issue";

/**
 * An Issue
 */
@customElement('my-issue')
export class MyIssue extends LitElement {
    static styles = css`
      :host {
        display: flex;
        flex-direction: column;
        border-radius: 1.5rem;
        margin: 1rem;
        background-color: #c8c8c8;
        overflow: hidden;
        font-family: Roboto, serif;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.30), 0 0 0 rgba(0, 0, 0, 0.22);
        transition: all .2s cubic-bezier(0, 0, 0.2, 1);
        transform: translate(0px, 0px);
      }

      :host(:hover) {
        box-shadow: 0 19px 38px rgba(0, 0, 0, 0.30), 0 15px 12px rgba(0, 0, 0, 0.22);
        transform: translate(0px, -5px) scale(1.02);
        cursor: pointer;
      }

      :host div {
        padding: 0 1rem;
      }

      .head {
        display: flex;
        flex-direction: row;
        justify-content: space-between;
        background-color: #dddddd;
        font-size: 24px;
        color: #515151;
        font-weight: bold;
      }

      .body {
        font-size: 16px;
        color: #373737;
        overflow: hidden;
      }

      p {
        margin: 0;
        padding: .8rem 0;
      }
      
      .title {
        text-overflow: ellipsis;
        white-space: nowrap;
        flex-shrink: 1;
        overflow: hidden;
      }
      
      .description {
        // TODO
        text-overflow: ellipsis;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }
    `
    @property({type: Issue}) issue: Issue = new Issue("", 123, "", "")

    render() {
        return html`
          <div class="head">
            <p class="title">${this.issue.title}</p>
            <p>#${this.issue.number}</p>
          </div>
          <div class="body">
            <p class="description">
              ${this.issue.description}
            </p>
          </div>
        `
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-issue': MyIssue
    }
}
