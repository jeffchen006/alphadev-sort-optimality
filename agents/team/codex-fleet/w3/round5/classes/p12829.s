# n=5 model=out iset=I1 prefix14_class=12829
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
mov S0, P1
cmovle P2, S1
cmp P1, P0
cmovge S0, P0
cmovg P0, P1
mov S2, S0
cmp P2, S2
cmovge S2, P2
cmovle S0, P2
cmp P3, P0
mov S0, P3
