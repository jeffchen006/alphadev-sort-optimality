# n=5 model=out iset=I1 prefix14_class=1317
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovle P2, S0
mov S1, P3
cmp P3, P0
cmovge S1, P0
cmovg P0, P3
mov P3, P1
cmp P0, P2
cmovle S2, P0
cmovge S2, P2
cmovg P2, P0
mov P0, S2
