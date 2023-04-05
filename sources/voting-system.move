module std::Voting
{ 
    use std::vector;
    use std::simple_map::{SimpleMap,Self};
    use std::signer; 

    struct CandidateList has key
    {
        candidate_list : SimpleMap< address,u64>,
        c_list : vector<address>,
        winner : address
    }


    struct VoterList has key
    {
        voters_list : SimpleMap<address,u8>
    }

    entry fun making_candidiate(acc: &signer,c_addrx:address) acquires CandidateList
    {   
        let signer_address = signer::address_of(acc);
        assert!(signer_address==@my_addrx,1); //you are not the owner

        if(!exists<CandidateList>(signer_address))
        {
            // let map:SimpleMap<address,u64> = simple_map::create();
            let r = CandidateList{
                candidate_list:simple_map::create(),
                c_list:vector::empty<address>(),
                winner:@0x0
            };
            move_to(acc,r);

        };
        
        let map = borrow_global_mut<CandidateList>(@my_addrx);

        
        
        assert!(simple_map::contains_key(&mut map.candidate_list,&c_addrx),1);  //candidate already exists

        simple_map::add(&mut map.candidate_list,c_addrx ,0);
        vector::push_back(&mut map.c_list, c_addrx);

   
    }

    public entry fun giving_vote(acc: &signer,c_addrx:address,v_addrx:address) acquires VoterList ,CandidateList
    {
        let signer_address = signer::address_of(acc);
        assert!(signer_address==@my_addrx,1); //you are not the owner
        
        if(!exists<CandidateList>(signer_address))
        {
            let r = CandidateList{
                candidate_list:simple_map::create(),
                c_list:vector::empty<address>(),
                winner:@0x0
            };
            move_to(acc,r);

        };
        if(!exists<VoterList>(signer_address))
        {
            let r = VoterList{
                voters_list:simple_map::create()
            };
            move_to(acc,r);

        };

        let map = borrow_global_mut<CandidateList>(@my_addrx);
        let tmp= borrow_global_mut<VoterList>(@my_addrx);


        assert!(simple_map::contains_key(&mut tmp.voters_list,&v_addrx)==true,1);//you have already voted
        
        simple_map::add(&mut tmp.voters_list,v_addrx ,1);

        if(simple_map::contains_key(&mut map.candidate_list,&c_addrx)){
            let v=simple_map::borrow_mut(&mut map.candidate_list,&c_addrx);
            *v=*v+1;
        }
        else
        {
            simple_map::add(&mut map.candidate_list,c_addrx ,1);
        }


    } 


    entry fun declare_winner(acc: &signer)  acquires CandidateList
    {
        let signer_address = signer::address_of(acc);
        assert!(signer_address==@my_addrx,1); //you are not the owner


        if(!exists<CandidateList>(signer_address))
        {
            abort 1 //no one vote

        };



        let map = borrow_global<CandidateList>(@my_addrx);

        let winner:address=@0x0;
        let maxx:u64=0;
        let total_candidates = vector::length(&map.c_list);
        let i=0;
        while(i < total_candidates)
        {
            let can = *vector::borrow(& map.c_list,(i as u64));
            let votes=simple_map::borrow(& map.candidate_list,&can);
            
            if(maxx < *votes)
            {
                maxx = *votes;
                winner = can;
            };
            i=i+1;
        };


        let map = borrow_global_mut<CandidateList>(@my_addrx);
        map.winner = winner;



    }



}
