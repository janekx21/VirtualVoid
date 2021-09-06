import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {LandingPageComponent} from './landing-page/landing-page.component';
import {HomeRoutingModule} from "./home-routing.module";

@NgModule({
  declarations: [
    LandingPageComponent
  ],
  imports: [
    CommonModule,
    HomeRoutingModule
  ]
})
export class HomeModule {
}
