import {LitElement, html, customElement, css} from 'lit-element'
import "./my-board";
import "./my-modal";

/**
 * The App
 */
@customElement('my-app')
export class MyApp extends LitElement {
    static style = css`
      :host {
        display: flex;
        flex-direction: column;
      }
    `

    render() {
        return html`
          <my-board></my-board>
        `
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-app': MyApp
    }
}
