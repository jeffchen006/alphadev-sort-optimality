# n=5 model=out iset=I1 prefix14_class=5960
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
cmovle P0, P1
mov P1, P3
cmp P1, P2
cmovg P3, P2
cmovg P2, P1
cmovl P1, P2
cmp P2, S2
cmovl P2, S2
cmovge P1, S2
cmp P3, P0
cmovle S2, P0
