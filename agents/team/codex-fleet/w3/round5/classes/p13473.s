# n=5 model=out iset=I1 prefix14_class=13473
cmp P0, P2
cmovge S1, P0
cmovle S1, P2
cmovle P2, P0
cmp P3, P1
mov P0, P1
cmovl P0, P3
cmovle P3, P1
cmp P2, P0
mov P1, P0
cmovg P0, P2
cmovge P2, P1
cmp P3, S1
cmovg S2, S1
