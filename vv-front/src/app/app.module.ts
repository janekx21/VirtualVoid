import {NgModule} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';

import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {BoardViewComponent} from './board-view/board-view.component';
// carbon-components-angular default imports
import {UIShellModule, IconModule} from 'carbon-components-angular';
import {HeaderComponent} from './header/header.component';

@NgModule({
  declarations: [
    AppComponent,
    BoardViewComponent,
    HeaderComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    UIShellModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule {
}
