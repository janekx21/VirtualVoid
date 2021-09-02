import {LitElement, html, customElement, css, state} from 'lit-element'
import "./my-issue"
import "./my-issue-detail"
import "./my-modal"
import Issue from "./Issue";

/**
 * An State with Issues
 */
@customElement('my-state')
export class MyState extends LitElement {
    static styles = css`
      :host {
        display: flex;
        flex-direction: column;
        margin: 1rem;
        background-color: #959595;
        min-width: 0;
      }

      .head {
        display: flex;
        justify-content: center;
        background-color: #c3c3c3;
        font-size: 40px;
        font-family: 'Merriweather', serif;
        color: #5e5e5e;
      }

      p {
        margin: 0;
        padding: .8rem 0;
      }
    `
    issues: Issue[] = [
        new Issue("123", 123, "issue title", "issue description"),
        new Issue("123", 312, "other issue", "issue description this one has a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des a rilly long des "),
        new Issue("123", 456, "third kind with a rilly long text", "issue description"),
    ]

    render() {
        return html`
          <div class="head"><p>TODO</p></div>
          <div>
            ${this.issues.map(i => html`
              <my-issue @click="${() => this.open(i)}" .issue="${i}"></my-issue>
            `)}
          </div>
          ${this.opened !== null ? html`
            <my-modal @close="${this.close}" .visable="true">
              <my-issue-detail @change="${(e: CustomEvent<Issue>) => this.opened = e.detail}" .issue="${this.opened}"></my-issue-detail>
            </my-modal>
          ` : html``}
        `
    }

    @state() opened: Issue | null = null

    private open(issue: Issue) {
        this.opened = issue
    }

    private close() {
        this.opened = null
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-state': MyState
    }
}
