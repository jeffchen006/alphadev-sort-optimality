# n=5 model=out iset=I1 prefix14_class=3469
mov S0, P0
mov S1, P2
cmp P3, P2
cmovge S1, P3
cmovg P3, P2
cmp S0, P1
cmovge P0, P1
cmovle S0, P1
mov P1, P0
cmp P3, P1
cmovg P0, P3
cmovg P3, P1
cmp S1, S0
cmovle P1, S0
