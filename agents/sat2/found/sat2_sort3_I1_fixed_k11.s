# n=3 R=14 iset=I1 model=reg source=sat2_cnf_cegis k=11
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
mov S1, P2
cmp S1, P0
cmovl P2, P0
cmovg S1, P0
cmp P1, P0
cmovl P0, P1
cmovle P1, S1
