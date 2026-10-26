# n=5 model=out iset=I1 prefix14_class=11797
cmp P1, P3
cmovle S1, P3
cmovg S1, P1
cmovle P3, P1
cmp P0, P2
mov S2, P2
cmovl S2, P0
cmovl P0, P2
cmp S1, P0
cmovg P1, P0
cmovge P0, S1
cmovg S1, P1
cmp S2, P3
cmovl P2, P3
