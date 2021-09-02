import {LitElement, html, customElement, css} from 'lit-element'
import "./my-state";

/**
 * A Board
 */
@customElement('my-board')
export class MyBoard extends LitElement {
    static styles = css`
      :host {
        display: flex;
        flex-direction: row;
      }
    `

    render() {
        return html`
          <my-state></my-state>
          <my-state></my-state>
          <my-state></my-state>
        `
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-board': MyBoard
    }
}
