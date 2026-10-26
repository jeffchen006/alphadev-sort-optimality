# n=5 model=out iset=I1 prefix14_class=6129
cmp P2, P1
cmovge S0, P1
cmovle S0, P2
cmovle P2, P1
mov P1, P3
cmp P0, P3
cmovge P1, P0
cmovge P0, P3
cmp P2, P1
cmovge P3, P2
cmovg P2, P1
mov S1, S0
cmovg P1, P3
cmp P0, S0
