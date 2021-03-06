Dosubl Persistent hash across datasteps and procedures                                                        
                                                                                                              
Persistent HASH - Thanks to Fried  Egg and SAS PTRLONGADD function                                            
                                                                                                              
Not sure how this scales?                                                                                     
                                                                                                              
Problem:  Given State, Year and Health Praticioner Type                                                       
          lookup the number of Practiomers using in the time and geography.                                   
                                                                                                              
This is an oversimplified example, mutiple 'dosubls' are possible and mutiple                                 
master tables should be possible.                                                                             
                                                                                                              
Build a Hash and use the Hash for mutiple procedures and datasteps                                            
                                                                                                              
A realize there are much simple qays to do the lookup but this uses a 'persistent' hash.                      
                                                                                                              
github                                                                                                        
http://tinyurl.com/yys4wywv                                                                                   
https://github.com/rogerjdeangelis/utl-dosubl-persistent-hash-across-datasteps-and-procedures                 
                                                                                                              
*_                   _                                                                                        
(_)_ __  _ __  _   _| |_                                                                                      
| | '_ \| '_ \| | | | __|                                                                                     
| | | | | |_) | |_| | |_                                                                                      
|_|_| |_| .__/ \__,_|\__|                                                                                     
        |_|                                                                                                   
;                                                                                                             
                                                                                                              
 options ls=171;                                                                                              
 data have(drop=rep);                                                                                         
     length question $15;                                                                                     
     do rep=1 to 10;                                                                                          
      do job="DOC","DEN","NUR";                                                                               
       do State="FL",'NY';                                                                                    
         do specialty="FAMLEE","INTMED";                                                                      
           do year="2000","2005";                                                                             
             question=cats(job,state,specialty,year);                                                         
             NUM_PRACT=int(100*uniform(5731));                                                                
             output;                                                                                          
           end;                                                                                               
         end;                                                                                                 
       end;                                                                                                   
     end;                                                                                                     
    end;                                                                                                      
run;quit;                                                                                                     
                                                                                                              
/*                                                                                                            
 WORK.HAVE total obs=240                                                                                      
                                                                                                              
         QUESTION        JOB    STATE    SPECIALTY    YEAR   NUM_PRACT                                        
                                                                                                              
1      DOCFLFAMLEE2000    DOC     FL       FAMLEE      2000      2                                            
2      DOCFLFAMLEE2005    DOC     FL       FAMLEE      2005     57                                            
3      DOCFLINTMED2000    DOC     FL       INTMED      2000     39                                            
4      DOCFLINTMED2005    DOC     FL       INTMED      2005     61                                            
5      DOCNYFAMLEE2000    DOC     NY       FAMLEE      2000     70                                            
6      DOCNYFAMLEE2005    DOC     NY       FAMLEE      2005     92                                            
 ....                                                                                                         
                                                                                                              
237    NURNYFAMLEE2000    NUR     NY       FAMLEE      2000      5                                            
238    NURNYFAMLEE2005    NUR     NY       FAMLEE      2005     31                                            
239    NURNYINTMED2000    NUR     NY       INTMED      2000      6                                            
240    NURNYINTMED2005    NUR     NY       INTMED      2005      0                                            
*/                                                                                                            
                                                                                                              
 options ls=171;                                                                                              
 data lookup(drop=rep);                                                                                       
     length question $15;                                                                                     
     do rep=1 to 10;                                                                                          
      do job="DOC","DEN","NUR";                                                                               
       do State="FL",'NY';                                                                                    
         do specialty="FAMLEE","INTMED";                                                                      
           do year="2000","2005";                                                                             
             question=cats(job,state,specialty,year);                                                         
             if uniform(5731) < .04 then output;                                                              
           end;                                                                                               
         end;                                                                                                 
       end;                                                                                                   
     end;                                                                                                     
    end;                                                                                                      
run;quit;                                                                                                     
                                                                                                              
                                                                                                              
/* LOOKUP THESE 13                                                                                            
                                                            RULES                                             
 WORK.LOOKUP total obs=13                                   Hash lookup to                                    
                                                            add number of practitioners                       
                                                                                                              
     QUESTION        JOB    STATE    SPECIALTY    YEAR    |  NUM_PRACT                                        
                                                          |                                                   
  DOCFLFAMLEE2000    DOC     FL       FAMLEE      2000    |    2                                              
  DENNYFAMLEE2005    DEN     NY       FAMLEE      2005    |    3                                              
  DOCNYFAMLEE2000    DOC     NY       FAMLEE      2000    |   70                                              
  DOCNYFAMLEE2000    DOC     NY       FAMLEE      2000    |   70                                              
  DENNYINTMED2000    DEN     NY       INTMED      2000    |   70                                              
  NURNYINTMED2000    NUR     NY       INTMED      2000    |    7                                              
  DOCNYFAMLEE2000    DOC     NY       FAMLEE      2000    |   70                                              
  DENFLFAMLEE2000    DEN     FL       FAMLEE      2000    |   36                                              
  DOCFLINTMED2005    DOC     FL       INTMED      2005    |   61                                              
  DOCNYINTMED2000    DOC     NY       INTMED      2000    |   81                                              
  DOCFLINTMED2000    DOC     FL       INTMED      2000    |   39                                              
  DENNYFAMLEE2005    DEN     NY       FAMLEE      2005    |    3                                              
  NURNYINTMED2005    NUR     NY       INTMED      2005    |    8                                              
*/                                                                                                            
                                                                                                              
*            _               _                                                                                
  ___  _   _| |_ _ __  _   _| |_                                                                              
 / _ \| | | | __| '_ \| | | | __|                                                                             
| (_) | |_| | |_| |_) | |_| | |_                                                                              
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                             
                |_|                                                                                           
;                                                                                                             
                                                                                                              
PROC PRINT HASH TABLE OUTPUT                                                                                  
----------------------------                                                                                  
                                                     Rules                                                    
WORK.DOSUBL total obs=13                             Hash lookup to                                           
                                                     add number of practitioners                              
                                                                                                              
Obs    OCCUPATION    STATE    SPECIALTY    YEAR   |  NUM_PRACT                                                
                                                  |                                                           
  1       DOC         FL       FAMLEE      2000   |    2                                                      
  2       DEN         NY       FAMLEE      2005   |    3                                                      
  3       DOC         NY       FAMLEE      2000   |   70                                                      
  4       DOC         NY       FAMLEE      2000   |   70                                                      
  5       DEN         NY       INTMED      2000   |   70                                                      
  6       NUR         NY       INTMED      2000   |    7                                                      
  7       DOC         NY       FAMLEE      2000   |   70                                                      
  8       DEN         FL       FAMLEE      2000   |   36                                                      
  9       DOC         FL       INTMED      2005   |   61                                                      
 10       DOC         NY       INTMED      2000   |   81                                                      
 11       DOC         FL       INTMED      2000   |   39                                                      
 12       DEN         NY       FAMLEE      2005   |    3                                                      
 13       NUR         NY       INTMED      2005   |    8                                                      
                                                                                                              
                                                                                                              
REPORT SUMS BY SATE AND PRACTITIONER PROC CORRESP                                                             
-------------------------------------------------                                                             
                                                                                                              
 WORK.DOSUB_CNT TOTAL OBS=13                                                                                  
                                                                                                              
 Obs    STATE    DEN    DOC    NUR      SUM                                                                   
                                                                                                              
  1      FL       36    102      0      138                                                                   
  2      NY       76    291     15      382                                                                   
                                                                                                              
  3      Sum     112    393     15      520                                                                   
                                                                                                              
*          _       _   _                                                                                      
 ___  ___ | |_   _| |_(_) ___  _ __                                                                           
/ __|/ _ \| | | | | __| |/ _ \| '_ \                                                                          
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                         
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                         
;                                                                                                             
                                                                                                              
data _null_;                                                                                                  
                                                                                                              
    if _n_=0 then do;                                                                                         
       %let rc=%sysfunc(dosubl('                                                                              
         data _null_;                                                                                         
            set lookup nobs=_nobs;                                                                            
            call symputx("_nobs",_nobs);                                                                      
         run;quit;                                                                                            
       '));                                                                                                   
    end;                                                                                                      
                                                                                                              
    length question $15;                                                                                      
    declare hash lookUp();                                                                                    
    rc=lookUp.defineKey('question');                                                                          
    rc=lookUp.defineData('answer');                                                                           
    rc=lookUp.defineDone();                                                                                   
    do until(eof1);                                                                                           
      set have end=eof1;                                                                                      
      rc=lookUp.add();                                                                                        
    end;                                                                                                      
                                                                                                              
    array que[&_nobs] $15 _temporary_;                                                                        
    array ans[&_nobs] _temporary_;                                                                            
    do _i_=1 by 1 until ( dne );                                                                              
       set lookup end=dne;                                                                                    
       que[_i_]=question;                                                                                     
       rc=lookUp.find();                                                                                      
       ans[_i_]=answer;                                                                                       
    end;                                                                                                      
    adrQue=put(addrlong(que[1]),$hex16.);                                                                     
    adrAns=put(addrlong(ans[1]),$hex16.);                                                                     
    call symputx('adrQue',adrQue);                                                                            
    call symputx('adrAns',adrAns);                                                                            
                                                                                                              
    rc=dosubl('                                                                                               
    data dosub;                                                                                               
      do _i_=1 to &_nobs;                                                                                     
        que=peekclong (ptrlongadd ("&adrQue"x,(_i_-1)*15),15);                                                
        occupation = substr(que,1,3);                                                                         
        state      = substr(que,4,2);                                                                         
        specialty  = substr(que,6,6);                                                                         
        year       = substr(que,12,4);                                                                        
        answer     =input(peekclong (ptrlongadd ("&adrAns"x,(_i_-1)*8),8),rb8.);                              
        output;                                                                                               
        keep occupation state specialty year answer;                                                          
      end;                                                                                                    
                                                                                                              
      * Two reports;                                                                                          
      proc print data=dosub;                                                                                  
      run;quit;                                                                                               
      ods exclude all;                                                                                        
      proc corresp data=dosub dim=1 observed;                                                                 
      ods output observed=dosub_cnt(rename=label=state);                                                      
         tables state, occupation;                                                                            
         weight answer;                                                                                       
      run;quit;                                                                                               
      ods select all;                                                                                         
                                                                                                              
      proc print data=dosub_cnt;                                                                              
      run;quit;                                                                                               
   ');                                                                                                        
run;quit;                                                                                                     
                                                                                                              
                                                                                                              
