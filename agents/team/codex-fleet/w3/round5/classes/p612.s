# n=5 model=out iset=I1 prefix14_class=612
mov S0, P0
cmp P3, P2
cmovle S2, P2
cmovg S2, P3
cmovg P3, P2
cmp S0, P1
cmovg S0, P1
cmovg P1, P0
mov P0, S2
mov P2, S0
cmp P1, P0
cmovge S2, P1
cmovle P0, P1
cmp P3, P2
