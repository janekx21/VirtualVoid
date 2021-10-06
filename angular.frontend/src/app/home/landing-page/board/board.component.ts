import {Component, OnInit} from '@angular/core';
import {Apollo, gql} from 'apollo-angular';

@Component({
  selector: 'app-board',
  templateUrl: './board.component.html',
  styleUrls: ['./board.component.scss']
})
export class BoardComponent implements OnInit {
  time: string = "foo"

  constructor(private apollo: Apollo) {
  }

  ngOnInit() {
    this.apollo
    .subscribe({
      query: gql`
        subscription {
          time
        }
      `,
    })
    .subscribe((result: any) => {
      // this.rates = result?.data?.rates;
      // this.loading = result.loading;
      // this.error = result.error;
      if (result.data !== null) {
        // this.time = result?.data?.time
      }
      console.log(result)
    });
  }

}
