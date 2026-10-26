# n=5 model=out iset=I1 prefix14_class=3303
mov S2, P3
mov S1, P0
cmp P1, S2
cmovle P3, P1
cmovg S2, P1
cmp P0, P2
cmovg P0, P2
cmovle S1, P2
cmp P3, P0
cmovle S0, P3
cmovl P3, P0
cmovg S0, P0
cmp S2, S1
cmovge P1, S1
