# n=5 model=out iset=I1 prefix14_class=12901
cmp P1, P0
cmovg S2, P1
cmovle S2, P0
cmovg P1, P0
cmp P3, P2
mov P0, P2
cmovle P0, P3
cmovle P3, P2
mov P2, P1
cmp P1, P0
cmovl P2, P0
cmovle P0, P1
cmp P3, S2
cmovge P1, P3
