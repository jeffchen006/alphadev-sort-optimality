# n=5 model=out iset=I1 prefix14_class=6465
mov S1, P1
cmp P1, P0
mov S2, P3
cmovle P1, P0
cmovl P0, S1
cmp P2, S2
cmovl P3, P2
cmovg S2, P2
cmp S2, P1
mov P2, S2
cmovg P2, P1
cmovge P1, S2
cmp P0, P3
cmovle S0, P3
