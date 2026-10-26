# n=5 model=out iset=I1 prefix14_class=1127
cmp P3, P0
mov S2, P0
cmovl P0, P3
cmovg S2, P3
mov P3, P2
cmp P1, P3
cmovge P3, P1
cmovg P1, P2
cmp S2, P3
mov S1, S2
cmovle S1, P3
cmovle P3, S2
cmp P1, P0
cmovle S2, P0
