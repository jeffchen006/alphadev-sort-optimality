# n=5 model=out iset=I1 prefix14_class=11718
cmp P3, P0
cmovle S1, P0
cmovg S1, P3
mov S2, P1
cmovle P0, P3
cmp S2, P2
cmovge S2, P2
cmovl P1, P2
cmp P1, S1
cmovge P2, P1
cmovg P1, S1
cmovge S1, P2
cmp S2, P0
cmovge P2, S2
