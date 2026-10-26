# n=5 model=out iset=I1 prefix14_class=6460
mov S2, P0
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmp P2, P3
mov S2, P2
cmovg S2, P3
cmovl P2, P3
mov P3, P2
cmp P3, P0
cmovge P3, P0
cmovg P0, P2
cmp S2, P1
cmovle S0, P1
