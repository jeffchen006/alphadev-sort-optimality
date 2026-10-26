# n=5 model=out iset=I1 prefix14_class=10509
mov S2, P0
cmp P3, S2
cmovge P0, P3
mov S1, P1
cmovle S2, P3
cmp S1, P2
cmovg S1, P2
cmovle P1, P2
cmp P0, P1
cmovle P3, P0
cmovl P0, P1
mov P0, S1
cmovl P1, P3
cmp S1, S2
