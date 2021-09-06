import {Component, OnInit} from '@angular/core';
/*
import Notification16 from '@carbon/icons/es/notification/16';
import UserAvatar16 from '@carbon/icons/es/user--avatar/16';
import AppSwitcher16 from '@carbon/icons/es/app-switcher/16';

 */
import {IconService} from "carbon-components-angular";

@Component({
  selector: 'app-board-view',
  templateUrl: './board-view.component.html',
  styleUrls: ['./board-view.component.scss']
})
export class BoardViewComponent implements OnInit {

  constructor(protected iconService: IconService) {
    /*
    iconService.registerAll([
      Notification16,
      UserAvatar16,
      AppSwitcher16
    ]);
     */
  }

  ngOnInit(): void {
  }

}
