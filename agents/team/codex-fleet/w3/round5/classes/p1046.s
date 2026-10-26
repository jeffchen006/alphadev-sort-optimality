# n=5 model=out iset=I1 prefix14_class=1046
mov S0, P0
cmp S0, P2
mov S1, P3
cmovle P0, P2
cmovl P2, S0
cmp S1, P1
cmovg S1, P1
cmovg P1, P3
mov S2, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, S2
cmp S1, P2
cmovg S0, S1
