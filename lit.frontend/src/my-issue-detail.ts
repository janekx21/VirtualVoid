import {LitElement, html, customElement, property, css, state} from 'lit-element'
import Issue from "./Issue";

/**
 * An Issue in Detail
 */
@customElement('my-issue-detail')
export class MyIssueDetail extends LitElement {
    static styles = css`
      :host {
        display: flex;
        flex-direction: column;
        border-radius: 1.5rem;
        margin: 1rem;
        background-color: #c8c8c8;
        overflow: hidden;
        font-family: Roboto, serif;
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

      p, textarea {
        margin: .4rem 0;
        padding: .4rem;
      }

      .title {
        text-overflow: ellipsis;
        white-space: nowrap;
        flex-shrink: 1;
        overflow: hidden;
      }

      .description {
        width: 100%;
        font-family: Roboto, sans-serif;
        font-size: 16px;
        min-height: 200px;
        box-sizing: border-box;
      }
      
      .zero-height {
        overflow: hidden;
        height: 0;
        min-height: 0;
        margin: 0;
        padding: 0;
      }
      
      textarea {
        border: none;
        background-color: transparent;
        outline: -webkit-focus-ring-color auto 1px;
        line-height: 16px;
        resize: vertical;
      }
      
      textarea:focus-visible {
        outline-offset: 0;       
      }
    `
    @property({type: Issue}) issue: Issue = new Issue("", 123, "", "")
    @state() isEditing = false;

    render() {
        return html`
          <div class="head">
            <p class="title">${this.issue.title}</p>
            <p>#${this.issue.number}</p>
          </div>
          <div class="body">
            <p class="description ${this.isEditing?'zero-height':''}" @click="${this.edit}">
              ${this.issue.description}
            </p>
            ${this.isEditing ? html`
              <textarea class="description" .value="${this.issue.description}"
                        @change="${this.change}"/>
            ` : html`
            `}
          </div>
        `
    }

    private edit() {
        this.isEditing = true;
    }

    private change(e: Event) {
        this.issue.description = (e.target as HTMLInputElement).value
        const event = new CustomEvent<Issue>('change', {bubbles: false, composed: true, detail: this.issue});
        this.dispatchEvent(event);
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-issue-detail': MyIssueDetail
    }
}
