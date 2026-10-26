# n=5 model=out iset=I1 prefix14_class=729
cmp P0, P2
mov S2, P1
mov S0, P0
cmovg S0, P2
cmovle P0, P2
cmp S2, P3
cmovle S2, P3
cmovg P1, P3
cmp P0, S2
mov P2, P0
cmovl P0, S2
cmovle S2, P2
cmp P1, S0
cmovge P0, P1
