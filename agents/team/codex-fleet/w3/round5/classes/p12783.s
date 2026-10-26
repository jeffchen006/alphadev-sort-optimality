# n=5 model=out iset=I1 prefix14_class=12783
cmp P0, P2
cmovg S2, P0
cmovg P0, P2
cmovg P2, S2
mov S1, P0
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovle P1, P3
cmp P0, S0
cmovge S1, S0
mov S1, P1
cmovg S0, P0
cmp P1, P2
