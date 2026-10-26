# n=5 model=out iset=I1 prefix14_class=11607
cmp P1, P2
cmovg S0, P1
cmovge P1, P2
cmovg P2, S0
cmp P0, P3
cmovle S2, P3
cmovge S2, P0
cmovle P3, P0
cmp P2, S2
mov P0, P2
cmovle P2, S2
mov S1, P3
cmovge P0, S2
mov P2, P0
