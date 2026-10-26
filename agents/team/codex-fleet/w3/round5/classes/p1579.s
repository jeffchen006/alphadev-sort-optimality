# n=5 model=out iset=I1 prefix14_class=1579
cmp P0, P3
mov S0, P0
cmovg P0, P3
mov S1, P1
cmovge P3, S0
cmp P2, S1
cmovg P1, P2
cmovle S1, P2
cmp P0, S1
cmovg P2, S1
cmovle P2, P0
cmovge S1, P0
mov P0, P3
mov P2, S1
