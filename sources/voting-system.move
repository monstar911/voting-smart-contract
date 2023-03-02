module voting_system::votings{    
    use std::debug;
    use std::vector;

    //errors
    const ALREADY_VOTED:u64 = 10;
    const NOT_A_VALID_CANDIDATE_ID:u64 = 11;

    //Information of candidate
    struct Candidate  has store,key,drop,copy {
        name : vector<u8>,
        candidate_id : vector<u8>,
        vote_count: u64
    }

    //List of candidates
    struct Candidates has store,key ,drop {
        list_of_candidates:vector<Candidate>
    }

    //Information of voter
    struct Voter  has store,key,drop,copy {
        name : vector<u8>,
        voter_id : vector<u8>,
        has_voted: bool,
        candidate_id :vector<u8>
    }

    //List of Voters
    struct Voters has store,key ,drop {
        list_of_voters:vector<Voter> 
    }
  

    //functions 
    fun adding_candidate(name :vector<u8> ,candidate_id :vector<u8> ,vote_count :u64,c : &mut Candidates)
    {
        let temp = Candidate {
            name:name,
            candidate_id:candidate_id,
            vote_count:vote_count
        };
        vector::push_back(&mut c.list_of_candidates,temp);

    }

    fun adding_voter(name :vector<u8> ,voter_id :vector<u8> ,has_voted :bool,candidate_id :vector<u8>,v : &mut Voters)
    {
        let temp = Voter {
            name:name,
            voter_id:voter_id,
            has_voted:has_voted,
            candidate_id:candidate_id
        };
        vector::push_back(&mut v.list_of_voters,temp);
        

    }

    fun giving_vote(candidate_id : vector<u8>,c :&mut  Candidates) : u64{
        let total_candidates = vector::length(&c.list_of_candidates);
        let i=0;
        while(i < total_candidates)
        {
            let can = *vector::borrow(&mut c.list_of_candidates,(i as u64));
            if(can.candidate_id==candidate_id)
            {    
                return i
            };
            i=i+1;
        };
        assert!(false,NOT_A_VALID_CANDIDATE_ID);
        0
    }

    fun result(c: &mut Candidates,v : &mut Voters) : Candidate{
        let maxx= 0;
        let winner= Candidate{
            name :vector::empty<u8>() ,
            candidate_id :vector::empty<u8>() ,
            vote_count : 0
        };
        let i=0;
        let total_voters = vector::length(&v.list_of_voters);
        while(i < total_voters)
        {
            let person = vector::borrow_mut(&mut v.list_of_voters,(i as u64));
            if(person.has_voted==true)
                abort(ALREADY_VOTED);
            person.has_voted=true;

            let candidate_id=person.candidate_id;
            let index = giving_vote(candidate_id,c);
            let cann = vector::borrow_mut(&mut c.list_of_candidates,(index as u64));
            cann.vote_count=cann.vote_count+1;
            i=i+1;
        };
        

        i=0;
        let total_candidates = vector::length(&c.list_of_candidates);
        while(i < total_candidates)
        {
            let can = *vector::borrow(&c.list_of_candidates,(i as u64));
            let v=can.vote_count;
            if(v > maxx)
            {
                winner = can;
                maxx=v;
            };
            i=i+1;
           
        };
        
        winner
    }


    //testing voting system
    #[test]
    fun testing()
    {
        let a =Candidates{
            list_of_candidates:vector::empty<Candidate>()
        };
        adding_candidate(b"Geeta",b"cid_1",0,&mut a);
        adding_candidate(b"Seeta",b"cid_2",0,&mut a);
        adding_candidate(b"Pritam",b"cid_3",0,&mut a); 

        let b= Voters{
            list_of_voters:vector::empty<Voter>()
        };

        adding_voter(b"Gurshaan",b"vid_1",false,b"cid_1",&mut b);
        adding_voter(b"Abhi",b"vid_2",false,b"cid_2",&mut b);
        adding_voter(b"Vasu",b"vid_3",false,b"cid_2",&mut b);
        adding_voter(b"Dev",b"vid_4",false,b"cid_2",&mut b);
        adding_voter(b"Prabh",b"vid_5",false,b"cid_3",&mut b);
        adding_voter(b"Harry",b"vid_6",false,b"cid_3",&mut b);
        adding_voter(b"Ron",b"vid_7",false,b"cid_3",&mut b);
        adding_voter(b"Angella",b"vid_8",false,b"cid_3",&mut b);

        
    
        let winner = result(&mut a,&mut b);
        debug::print(&winner.name);
        assert!(winner.name == b"Pritam",0);

        
    }
    
}