# n=5 model=out iset=I1 prefix14_class=11168
cmp P0, P3
cmovg S1, P3
cmovle S1, P0
cmovg P3, P0
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
mov P0, P3
cmovg P2, S2
cmp P1, P0
cmovle P3, P1
cmovl P1, P0
mov P1, P2
cmp S1, P1
