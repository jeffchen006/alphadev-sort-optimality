# n=5 model=out iset=I1 prefix14_class=4250
mov S1, P3
cmp P0, P3
cmovle S1, P0
mov S2, P1
cmovg P3, P0
cmp P2, S2
cmovge P1, P2
cmovge P2, S2
mov S2, P2
cmp S1, P2
cmovg S2, S1
cmovl P2, S1
cmp P3, P1
cmovle P2, P1
