# n=5 model=out iset=I1 prefix14_class=6090
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovl P2, S0
cmp P1, P0
cmovge S1, P1
cmovg P1, P0
cmovle S1, P0
cmp S1, P3
cmovge P0, S1
cmovg S1, P3
cmovg P3, P0
mov P3, P2
cmp P2, P1
