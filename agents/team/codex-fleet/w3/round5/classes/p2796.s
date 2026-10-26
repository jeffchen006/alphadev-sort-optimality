# n=5 model=out iset=I1 prefix14_class=2796
mov S1, P3
cmp P0, P3
mov S0, P2
cmovle P3, P0
cmovge S1, P0
cmp P1, S0
cmovle P2, P1
cmovle P1, S0
cmp P1, S1
cmovg S0, S1
cmovg S1, P1
cmovg P1, S0
mov S1, P3
cmp P3, P2
