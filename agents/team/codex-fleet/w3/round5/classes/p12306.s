# n=5 model=out iset=I1 prefix14_class=12306
cmp P1, P2
cmovle S1, P1
cmovg S1, P2
cmovl P1, P2
cmp P3, P0
mov S2, P0
cmovg S2, P3
cmovle P0, P3
cmp P0, S1
cmovge P2, P0
mov P3, P1
cmovg P0, S1
cmovge S1, P2
mov P0, S1
