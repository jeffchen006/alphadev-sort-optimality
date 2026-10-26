# n=5 model=out iset=I1 prefix14_class=9223
mov S2, P3
cmp P0, P1
cmovg S0, P1
cmovg P1, P0
cmovg P0, S0
cmp S2, P2
cmovl S2, P2
cmovle P2, P3
cmp P0, P2
mov S1, P2
cmovge P2, P0
cmovle S1, P0
mov P0, S2
cmp S2, P1
