# n=5 model=out iset=I1 prefix14_class=11783
cmp P3, P0
mov S0, P0
cmovg P0, P3
mov S1, P2
cmovg P3, S0
cmp P1, S1
cmovge S1, P1
cmovle P2, P1
cmp P0, S1
cmovg S0, S1
cmovge S1, P0
mov S1, P2
cmovg P0, S0
cmp P3, S1
