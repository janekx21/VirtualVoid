import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {LandingPageComponent} from './landing-page/landing-page.component';
import {HomeRoutingModule} from "./home-routing.module";
import {TilesModule} from "carbon-components-angular";
import { BoardComponent } from './landing-page/board/board.component';

@NgModule({
  declarations: [
    LandingPageComponent,
    BoardComponent
  ],
  imports: [
    CommonModule,
    HomeRoutingModule,
    TilesModule
  ]
})
export class HomeModule {
}
