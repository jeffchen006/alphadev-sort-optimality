# n=5 model=out iset=I1 prefix14_class=1749
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
mov S1, P1
cmovg P2, S2
mov S2, P0
cmp P3, S2
cmovl P0, P3
cmovle P3, S2
cmp P1, P3
cmovle S1, P3
cmovg P1, P3
cmp P2, P0
cmovge S1, P2
