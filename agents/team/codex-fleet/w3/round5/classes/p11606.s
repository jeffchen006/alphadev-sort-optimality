# n=5 model=out iset=I1 prefix14_class=11606
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmovg P2, S1
cmp P1, P0
cmovle S0, P0
cmovge S0, P1
cmovle P0, P1
cmp P2, S0
cmovge P1, P2
cmovge P2, S0
cmovle P1, S0
mov P1, P2
cmp P3, P0
