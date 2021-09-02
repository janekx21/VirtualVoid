import {LitElement, html, customElement, css} from 'lit-element'

/**
 * An State with Issues
 */
@customElement('my-modal')
export class MyModal extends LitElement {
    static styles = css`
      :host {
        z-index: 1;
      }

      .root {
        position: absolute;
        background-color: rgba(0, 0, 0, 50%);
        top: 0;
        left: 0;
        width: 100vw;
        height: 100vh;
        display: flex;
        flex-direction: row;
        justify-content: center;
      }

      .container {
        display: flex;
        flex-direction: column;
        justify-content: center;
      }
    `

    render() {
        return html`
          <div class="root" @click="${this.hide}">
            <div class="container">
              <slot @click="${this.stop}"></slot>
            </div>
          </div>
        `
    }

    private hide() {
        const event = new CustomEvent('close', {bubbles: false, composed: true});
        this.dispatchEvent(event);
    }

    private stop(e: Event) {
        e.stopPropagation()
    }
}

declare global {
    interface HTMLElementTagNameMap {
        'my-modal': MyModal
    }
}
