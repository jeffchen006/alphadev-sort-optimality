# n=5 model=out iset=I1 prefix14_class=830
cmp P1, P3
mov S2, P1
cmovg P1, P3
cmovle S2, P3
mov P3, P0
cmp P2, P0
mov S0, S2
cmovle P0, P2
cmovg P3, P2
cmp P3, S2
cmovle S2, P3
cmovge S0, P3
mov P2, S2
mov S1, P0
