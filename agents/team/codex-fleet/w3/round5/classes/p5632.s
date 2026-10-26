# n=5 model=out iset=I1 prefix14_class=5632
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
mov S0, P1
cmovle S2, P2
mov P2, P3
cmp P3, P0
cmovle P3, P0
cmovle P0, P2
cmp S0, P0
cmovg P1, P0
cmovg P0, S0
cmp P3, S2
cmovg S0, P3
