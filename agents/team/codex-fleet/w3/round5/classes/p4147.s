# n=5 model=out iset=I1 prefix14_class=4147
cmp P3, P2
cmovg S2, P2
cmovge P2, P3
cmovle S2, P3
mov P3, P1
cmp P0, P1
cmovl P1, P0
cmovg P3, P0
mov S1, P1
cmp S2, S1
cmovle S1, S2
cmovge P1, S2
cmp P2, P3
cmovge P0, P2
