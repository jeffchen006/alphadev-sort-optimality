# n=3 R=14 iset=I0 model=reg source=sat2_cnf_cegis k=11
mov S0, P0
mov S1, P1
cmp P2, P0
cmovl P0, P2
cmovl P2, S0
cmp S1, P2
cmovg P1, P2
cmovg P2, S1
cmp P0, P1
cmovg P1, P0
cmovg P0, S1
