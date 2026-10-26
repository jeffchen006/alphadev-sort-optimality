# n=5 model=out iset=I1 prefix14_class=14208
mov S1, P1
cmp P1, P0
cmovge P1, P0
cmovl S1, P0
cmp P3, P2
mov S2, P2
cmovge P2, P3
cmovg P3, S2
cmp S1, P2
mov P0, P3
cmovle S2, P2
cmovle P2, S1
cmovle S1, S2
mov S1, P2
