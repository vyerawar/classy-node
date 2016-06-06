import Resource from '../ClassyResource';

class Transactions extends Resource {
  constructor(Classy) {
    super(Classy, {
      basic: ['retrieve', 'update'],
      lists: ['registrations', 'items', 'acknowledgements'],
      creates: ['dedications'],
      path: '/transactions'
    });
  }
}

export default Transactions;
