# n=5 model=out iset=I1 prefix14_class=8354
cmp P2, P1
cmovle S0, P1
cmovle P1, P2
cmovge S0, P2
cmp P3, P0
cmovge P2, P3
cmovge P3, P0
mov S2, P1
cmovg P0, P2
cmp P3, S2
mov S1, S0
cmovge S2, P3
cmovg P3, P1
mov P3, S2
