# n=5 model=out iset=I1 prefix14_class=6634
cmp P1, P3
cmovge S0, P1
cmovle S0, P3
mov S2, S0
cmovle P3, P1
mov P1, P0
cmp P1, P2
cmovge P0, P2
cmovle P1, P2
cmp S0, P1
cmovge S0, P1
cmovg P1, S2
cmp P0, P3
cmovge P2, P0
