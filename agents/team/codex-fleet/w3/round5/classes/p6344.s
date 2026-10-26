# n=5 model=out iset=I1 prefix14_class=6344
cmp P3, P2
cmovge S0, P3
cmovge P3, P2
cmovg P2, S0
cmp P0, P1
cmovle S2, P1
cmovl P1, P0
mov S1, P2
cmovg S2, P0
cmp S2, S1
cmovg S1, S2
cmovle P2, S2
cmp P1, P3
mov P0, P2
