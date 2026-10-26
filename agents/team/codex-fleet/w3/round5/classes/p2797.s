# n=5 model=out iset=I1 prefix14_class=2797
mov S1, P3
cmp P0, P3
cmovle P3, P0
mov S0, P1
cmovge S1, P0
cmp P2, S0
cmovle P1, P2
cmovle P2, S0
cmp P2, S1
cmovge S0, S1
cmovg S1, P2
cmovg P2, S0
mov S1, P3
cmp S1, P1
